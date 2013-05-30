#
# Cookbook Name:: postgresql
# Recipe:: ssl_cert
#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright:: Copyright (c) 2013, Opscode, Inc. <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

x509_subject = node['postgresql']['server']['x509_subject']

openssl_x509 node['postgresql']['config']['ssl_cert_file'] do
  common_name x509_subject['common_name'] || node['fqdn']
  org x509_subject['org']
  org_unit x509_subject['org_unit']
  country x509_subject['country']
  expire x509_subject['expire'] if x509_subject.has_key?('expire')
  key_file node['postgresql']['config']['ssl_key_file']
  mode 00644
end

# The openssl_x509 resource doesn't support setting the key file mode,
# only the certificate. PostgreSQL expects restricted permission on
# the key.
file node['postgresql']['config']['ssl_key_file'] do
  mode 00640
end

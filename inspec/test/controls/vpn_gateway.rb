# control 'hub_to_hub_peering' do
#     title "Check peering status"

#   describe azure_virtual_network_gateway_connection(resource_group: 'rg-appserviceplanintegration', name: 'testpeer') do
#       its('properties.connectionStatus') { should eq 'Connected' }
#     end
#   end
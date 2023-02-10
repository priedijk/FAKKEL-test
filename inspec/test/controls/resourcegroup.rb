# # sample compliance test to verify the resource group exists or not
# control 'azure_resource_group' do 
#   title "Check resource group" 
#   desc "Check if resource group is present" 
#   describe azure_resource_group(name: 'tfstatetestfakkel') do 
#   it { should exist } 
#   end 
# end 
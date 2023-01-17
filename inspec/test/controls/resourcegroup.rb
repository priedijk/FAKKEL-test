# sample compliance test to verify the resource group exists or not
control "azure-rg-exists-sample" do   
    impact 0.1
    desc "sample test to verify any resource group exists in the subscription"    
    describe azure_resource_groups do
      it { should exist }
    end
  end
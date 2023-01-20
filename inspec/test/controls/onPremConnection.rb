# Verify host name is reachable over a specific protocol and port number 

# describe host('example.com', port: 80, protocol: 'tcp') do
#   it { should be_reachable }
# end


# Review the connection setup and socket contents when checking reachability 

# describe host('example.com', port: 12345, protocol: 'tcp') do
#   it { should be_reachable }
#   its('connection') { should_not match /connection refused/ }
#   its('socket') { should match /STATUS_OK/ }
# end
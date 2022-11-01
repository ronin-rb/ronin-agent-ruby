#!/usr/bin/env bash

output="${1:-agent.rb}"

echo "#!/usr/bin/env ruby" > "$output"
cat lib/agent/rpc/*.rb >> "$output"
cat lib/agent/rpc.rb >> "$output"
cat lib/agent/message.rb >> "$output"
cat lib/agent/tcp/connect_back.rb >> "$output"
cat lib/agent/http/client.rb >> "$output"
cat lib/agent/main.rb >> "$output"
chmod +x "$output"

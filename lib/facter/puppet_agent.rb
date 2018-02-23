Facter.add(:puppet_agent) do
  setcode do
    puppet_facts = {}
    if Facter::Util::Resolution.which('puppet')
      puppet_config = Facter::Util::Resolution.exec('puppet config print')
      puppet_config.split("\n").each do |entry|
        parts = entry.split('=', 2) # Just in case = also appears in the value
        key   = parts[0].strip
        value = parts[1].strip

        # Attempt to convert Arrays and Hashes to their respective data types.
        if value =~ /^(\[.*\])$/ || value =~ /^(\{.*\})$/
          # Not everything that looks like JSON, is JSON.
          begin
            puppet_facts[key] = JSON.parse($1)
          rescue
            puppet_facts[key] = value
          end

        # Also check for actual Boolean values (ignore "Boolean-like" values)
        elsif value.eql?('true')
          puppet_facts[key] = true
        elsif value.eql?('false')
          puppet_facts[key] = false

        # Assume anything left is a String, but parse numeric values
        else
          puppet_facts[key] =
            begin
              Integer(value)
            rescue
              begin
                Float(value)
              rescue
                value
              end
            end
        end
      end
    end
    puppet_facts
  end
end

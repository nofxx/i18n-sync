module I18n
  module Sync
    class ::Hash
      # Ensures multilevel hash merging
      def deep_sync!(other_hash)
        other_hash.each do |k, v|
          next unless tv = self[k]
          self[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.dup.deep_sync!(v) : v
        end
        self
      end
    end
  end
end

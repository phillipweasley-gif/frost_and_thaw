# Syntax-checks every Ruby file in the game scripts and tools, one file at a time
# (`ruby -c a b c` only checks the first). Exit 1 if any fails.
#   ruby tools/syntax_all.rb
require "open3"
root = File.expand_path("..", __dir__)
files = Dir[File.join(root, "game/Data/Scripts/998_FrostThaw/*.rb")] + Dir[File.join(root, "tools/**/*.rb")] +
        Dir[File.join(root, "tests/*.rb")]
bad = files.reject do |f|
  out, st = Open3.capture2e(RbConfig.ruby, "-c", f)
  st.success? || (puts "#{f.sub(root + '/', '')}: #{out.lines.first(3).join}"; false)
end
puts bad.empty? ? "syntax OK: #{files.size} files" : "#{bad.size} of #{files.size} files have syntax errors"
exit(bad.empty? ? 0 : 1)

require_relative "rgss_stub"
id = ARGV[0].to_i
m = load_data(format("/home/claude/pif-682/Data/Map%03d.rxdata", id))
m.events.values.sort_by(&:id).each do |e|
  e.pages.each_with_index do |pg, i|
    cmds = pg.list.reject { |c| c.code == 0 }.map { |c| "#{c.code}:#{c.parameters.inspect[0, 90]}" }
    puts "#{e.id} #{e.name} (#{e.x},#{e.y}) p#{i} trig#{pg.trigger} g=#{pg.graphic.character_name} sw=#{pg.condition.switch1_valid ? pg.condition.switch1_id : '-'} ss=#{pg.condition.self_switch_valid ? pg.condition.self_switch_ch : '-'} :: #{cmds.first(ARGV[1] ? ARGV[1].to_i : 4).join(' | ')}"
  end
end

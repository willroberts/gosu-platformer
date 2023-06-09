# frozen_string_literal: true

class Sprite
  def self.sprite_dir = File.join(GameWindow.root_dir, 'sprites')

  def self.character(filename, **opts)
    self[File.join('character', filename), **opts]
  end

  def self.[](filename, **opts)
    cache[cache_key(filename, **opts)] ||=
      Gosu::Image.new(File.join(GameWindow.root_dir, 'sprites', filename), **opts)
  end

  def self.cache = @cache ||= {}

  def self.cache_key(filename, **opts)
    # example: "hud/hud0.png-tilable:true-dankness:bigly"
    formatted_opts = opts.map { |k, v| "#{k}:#{v}" }.join('-')
    separator = formatted_opts.empty? ? nil : '-'
    "#{filename}#{separator}#{formatted_opts}"
  end
end

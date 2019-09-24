class Pod
  COLORS_REGEXP_PATTERN = /\e\[(\d+)m/

  def initialize(name, current, update, latest)
    @pod_name = decolorize(name)
    @current_version = decolorize(current)
    @update_version = decolorize(update)
    @latest = decolorize(latest)
  end

  def decolorize(str)
     return str.gsub(COLORS_REGEXP_PATTERN,'')
  end

  attr_reader :pod_name
  attr_reader :current_version
  attr_reader :update_version
  attr_reader :latest
end

# encoding: utf-8
module AreaCN
  class Area
    # 有很多省(省会城市),市下面有"市辖区", 单纯的"市辖区"不能分辨是哪个地区的
    #
    # 如果是"市辖区"的地区返回带上级的名字
    def sense_name
      @sense_name ||= name == "市辖区" ? parent.name + "辖区" : name
    end
  end
end

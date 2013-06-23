#encoding: utf-8
class District
  ROOT_CODE = '000000'

  class << self
    def list(parent_id = '000000')
      result = []
      return result if parent_id.blank?
      id_match = parent_id.match(/(\d{2})(\d{2})(\d{2})/)
      province_id = id_match[1].ljust(6, '0')
      city_id = "#{id_match[1]}#{id_match[2]}".ljust(6, '0')
      children = self.data
      children = children[province_id][:children] if children.has_key?(province_id)
      children = children[city_id][:children] if children.has_key?(city_id)
      children.each_key do |id|
        result.push [ children[id][:text], id]  
      end

      #sort
      result.sort! {|a, b| a[1] <=> b[1]}
      result
    end

    # only return codes
    def list_codes(parent_id = '000000')
      list(parent_id).map { |name_code| name_code[1] }
    end

    # only return names
    def list_names(parent_id = '000000')
      list(parent_id).map { |name_code| name_code[0] }
    end

    def get(id)
      return '' if id.blank?
      return '全国' if id == ROOT_CODE
      children = self.data
      return children[id][:text] if children.has_key?(id)
      id_match = id.match(/(\d{2})(\d{2})(\d{2})/)
      province_id = id_match[1].ljust(6, '0')
      children = children[province_id][:children]
      return children[id][:text] if children.has_key?(id)
      city_id = "#{id_match[1]}#{id_match[2]}".ljust(6, '0')
      children = children[city_id][:children]
      return children[id][:text]
    end

    def match(name)
      area_data.select { |area| area['text'] =~ /^#{name}/ }
    end

    def get_code_by_name(name)
      region = area_data.detect { |area| area['text'] == name}
      region && region['id']
    end

    # code is id
    def code_prefix(id)
      return if id == ROOT_CODE
      id = id.sub(/0{2,4}$/, '')
      id << '0' if id.length.odd?

      id
    end

    def code_ancestors(id)
      ancestors = []
      ancestors << id while id = code_parent(id)

      ancestors
    end

    def code_ancestor?(code, child_code)
      District.code_ancestors(child_code).include?(code) 
    end

    def city?(id)
      return false if id == ROOT_CODE
      code_prefix(id).length == 4
    end

    def province?(id)
      return false if id == ROOT_CODE
      code_prefix(id).length == 2
    end

    def county?(id)
      return false if id == ROOT_CODE
      code_prefix(id).length == 6
    end
    alias_method :district?, :county?

    def code_chain(id)
      District.code_ancestors(id).reverse << id
    end

    def code_chain_list(id)
      id ||=ROOT_CODE
      area=["cn","provinces","cities","counties"]
      region = {};current = {} 
      code_chain(id).each_with_index do |code,index|
        current[area[index]] = code
        next if county?(code) 
        region[area[index + 1]] = list(code)
      end
      region[:current] = current
      region.reverse_merge("provinces"=>[],"cities"=>[],"counties"=>[])
    end

    def code_parent(id)
      return if id == ROOT_CODE
      prefix_id = code_prefix(id)
      parent = prefix_id.dup
      parent[-2..-1] = '00'
      parent.ljust(6, '0')
    end


    # 该方法没有危害，对传入的codes不改变，返回新建的对象
    def exclude_codes(codes, remove_codes)
      codes = codes.dup
      remove_codes = remove_codes.dup
      exclude_codes!(codes, remove_codes)
    end

    # 在已有地区中，把排除的地区去掉,例如: 在浙江省中去除杭州,宁波
    # 
    # 改方法直接修改传入的codes参数, 并返回
    def exclude_codes!(codes, remove_codes)
      remove_codes.each do |rcode| 
        exclude_code!(codes, rcode)
      end
      codes.uniq!

      codes
    end

    # 该方法没有危害，对传入的codes不改变，返回新建的对象
    def exclude_code(codes, remove_code)
      codes = codes.dup
      exclude_code!(codes, remove_code)
    end

    # 在已有地区中，把排除的地区去掉,例如: 在浙江省中去除杭州
    # 
    # 改方法直接修改传入的codes参数, 并返回
    def exclude_code!(codes, remove_code)
      detect_code = codes.detect { |code| District.code_ancestor?(code, remove_code) || code == remove_code }

      if detect_code == remove_code
        codes.delete(remove_code)
      else
        remove_code_parent = District.code_parent(remove_code)
        codes.concat District.list_codes(remove_code_parent)
        codes.delete(remove_code)
        exclude_code!(codes, remove_code_parent)
      end

      codes
    end

    def data
      unless @list
        #{ '440000' => 
        #  { 
        #    :text => '广东', 
        #    :children => 
        #      { 
        #        '440300' => 
        #          { 
        #            :text => '深圳', 
        #            :children => 
        #              { 
        #                '440305' => { :text => '南山' }
        #              } 
        #           }
        #       }
        #   }
        # }
        @list = {}
        #@see: http://github.com/RobinQu/LocationSelect-Plugin/raw/master/areas_1.0.json
        #json = JSON.parse(File.read("#{Rails.root}/db/areas.json"))
        districts = json_data.values.flatten
        districts.each do |district|
          id = district['id']
          text = district['text']
          id_match = id.match(/(\d{2})(\d{2})(\d{2})/)
          if id.end_with?('0000')
            @list[id] =  {:text => text, :children => {}}
          elsif id.end_with?('00')
            province_id = id_match[1].ljust(6, '0')
            @list[province_id] = {:text => nil, :children => {}} unless @list.has_key?(province_id)
            @list[province_id][:children][id] = {:text => text, :children => {}}
          else
            province_id = id_match[1].ljust(6, '0')
            city_id = "#{id_match[1]}#{id_match[2]}".ljust(6, '0')
            @list[province_id] = {:text => text, :children => {}} unless @list.has_key?(province_id)
            @list[province_id][:children][city_id] = {:text => text, :children => {}} unless @list[province_id][:children].has_key?(city_id)
            @list[province_id][:children][city_id][:children][id] = {:text => text}
          end
        end
      end
      @list
    end

    def json_data
      @json_data ||= JSON.parse(File.read("#{Rails.root}/db/areas.json"))
    end

    def area_data
      @area_data ||= json_data['province'].concat(json_data['city']).concat(json_data['district'])  
    end
  end

end

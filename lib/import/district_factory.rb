require_relative './helper/mapping_helper'

module Import
  class DistrictFactory
    include MappingHelper

    def initialize node, year = nil
      @node = node
      @year ||= 2012
    end

    def simple_attribute_mappings
      {
        'id' => [:leo_id],
        'name' => [:name],
      }
    end

    def list_element_mappings
      {
        'CLUBS' => [:clubs, club_lambda(@year)],
        'OFFICERS' => [:offices, office_lambda(@year)]
      }
    end

    def build_model save=false
      d = ::District.new

      extract_from_attribute_list list: @node.attributes, mapping: simple_attribute_mappings, entity: d
      extract_from_element_list list: @node.element_children.select{|c| c.element_children.size >= 1}, mapping: list_element_mappings, entity: d

      d.save! if save
      d
    end

  end
end
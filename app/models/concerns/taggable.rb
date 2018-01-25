# Taggable model concern
#
# Uses postgresql string arrays to provide tags without the additional tables.
#
module Taggable
  extend ActiveSupport::Concern

  Tag = Struct.new(:name, :count) do
    def downcase_name
      name.downcase
    end

    def initial
      name[0].capitalize
    end

    def to_s
      name.to_s
    end
  end

  included do
    scope :tagged_with, ->(tag) { where("? = ANY (tags)", tag) }
  end

  def tag_list
    tags && tags.join(", ")
  end

  def tag_list=(tag_list)
    self.tags = tag_list.reject(&:empty?)
  end

  # class methods (stupid comment to make rubocop happy)
  module ClassMethods
    def all_tags
      pluck(:tags).flatten.compact.reject(&:empty?)
    end

    def tag_list
      all_tags.uniq.sort
    end

    def find_like_tag(pattern)
      all_tags.uniq.select { |t| t =~ /#{pattern}/i }
    end

    # Buils a hash where the keys are the capital letters of the tags and the
    # values are the individual tags together with the number of their
    # occurrences
    #
    # @return [Hash<Array<Array<String, Integer>>>]
    def tag_cloud
      all_tags
        .group_by(&:to_s)
        .map { |tag_name, count| Tag.new(tag_name, count.size) }
        .sort_by { |tag| tag.downcase_name }
    end

    def find_like_tag(pattern)
      all_tags.uniq.select { |t| t =~ /#{pattern}/i }
    end

    def alphabetical_grouped_tags
      tag_cloud.group_by { |tag| tag.initial }
    end
  end
end

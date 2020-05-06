class Lesson < ApplicationRecord
  include Maawol::Models::Concerns::TmpUploadable

  acts_as_commentable

  has_and_belongs_to_many :videos
  has_and_belongs_to_many :audio_files
  has_and_belongs_to_many :downloadables
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :playlists
  has_and_belongs_to_many :users
  has_many :teachings
  has_many :courses, through: :teachings
  belongs_to :author, optional: false

  validates_presence_of :name
  before_save :set_slug
  before_save :set_access_level
  after_save  :migrate_file_from_tmp_upload, if: -> { self.tmp_media_id.present? }

  enum  access_level: [:global, :users]

  mount_uploader :thumbnail, LessonThumbnailUploader

  def field_for_upload
    :thumbnail
  end

  def self.table_name
    'lessons'
  end

  def self.default_thumbnail_asset_path
    ActionController::Base.helpers.asset_path "lessons/no-thumbnail.png"
  end

  def self.search(query)
    self.includes(:categories).includes(:tags)
        .where("lessons.name LIKE :query OR lessons.content LIKE :query OR categories.name LIKE :query OR tags.name LIKE :query", query: "%#{query}%")
        .references(:categories).references(:tags)
  end

  def self.latest(limit=4)
    self.published.where(course_only: false).order(publish_date: :desc).limit(limit)
  end

  def self.published
  	where('publish_date <= ?', Time.now).where(access_level: :global)
  end

  def self.in_category(id)
    includes(:categories).where("categories.id": id)
  end

  def self.in_root_category(id)
    includes(categories: :root_category).where("root_categories.id": id)
  end

  def comment_count
  	self.root_comments.size
  end

  def main_video
  	self.videos.first
  end

  def is_published
  	self.publish_date && self.publish_date <= Time.now
  end

  def available_for_user?(current_user)
    if current_user.has_full_account? || current_user.is_admin?
      true
    else
      self.is_free?
    end
  end

  def main_video
    videos.first
  end

  def content_with_omitted_excerpt
    @content_with_omitted_excerpt ||= begin
      if content_fragment_has_paragraphs?
        remainder_fragment = Nokogiri::HTML::fragment(self.content.squish)
        remainder_fragment.search('p').first.remove
        strip_empty_paragraphs(remainder_fragment).to_xhtml
      end
    end
  end

  def content_excerpt
    if content_fragment_has_paragraphs?
      first_content_para.text.strip
    else
      Nokogiri::HTML(self.content).text
    end
  end

  def stripped_empty_content
    strip_empty_paragraphs(content_fragment).to_xhtml
  end

  def has_taxonomies?
    self.tags.any? || self.categories.any?
  end

  def human_access_level
    self.access_level.to_sym == :global ? "All students" : "#{self.users.size} student#{self.users.size > 1 ? 's' : ''}"
  end

  def has_video?
    self.main_video.present?
  end

  def listing_thumbnail_path(size=:small)
    if thumbnail.present?
      thumbnail.url(size)
    else
      self.class.default_thumbnail_asset_path
    end
  end

  def active_videos
    self.videos.where(status: :uploaded)
  end

private

  def set_slug
    self.slug = self.name.parameterize
  end

  def set_access_level
    self.access_level = self.users.any? ? :users : :global
  end

  def content_fragment
    @content_fragment ||= Nokogiri::HTML::fragment(self.content.squish)
  end

  def content_fragment_has_paragraphs?
    content_fragment.search('p').any?
  end

  def first_content_para
    content_fragment.search('p').first
  end

  def strip_empty_paragraphs(fragment)
    fragment.css('p').find_all.each do |p|
      p.remove if p.content.blank? || p.content.strip.empty?
    end
    fragment
  end
end
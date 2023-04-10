require 'aws-sdk-s3'
# Set the host name for URL creation
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.default_host = "http://www.example.com"

# The remote host where your sitemaps will be hosted
SitemapGenerator::Sitemap.sitemaps_host = "https://some-storage.s3.eu-central-1.amazonaws.com/"

SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  "some-storage",
  aws_access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
  aws_secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
  aws_region: "eu-central-1"
)
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do

  add courses_path, priority: 0.7, changefreq: 'weekly'
  add tags_path, priority: 0.2, changefreq: 'monthy'

  add new_user_registration_path, priority: 0.8, changefreq: 'monthy'
  add new_user_session_path, priority: 0.8, changefreq: 'monthy'

  Course.where(published: true, approved: true).find_each do |course|
    add course_path(course), lastmod: course.updated_at
  end

end

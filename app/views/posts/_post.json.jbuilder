json.extract! post, :id, :caption, :photo, :created_at, :updated_at
json.url post_url(post, format: :json)
json.photo url_for(post.photo)

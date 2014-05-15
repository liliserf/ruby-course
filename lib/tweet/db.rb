class Tweet::DB
  attr_reader :text_tweets, :tags, :text_tweet_tags, :pic_tweets, :pic_tweet_tags

  def initialize
    @text_tweets = {}
    @next_tt_id = 0
    @tags = {}
    @next_tag_id = 0
    @text_tweet_tags = {}
    @text_tweet_tags_counter = 0
    @pic_tweets = {}
    @pic_tweet_counter = 0
    @pic_tweet_tags = {}
    @pic_tweet_tags_counter = 0
  end

  #########
  # Methods related to creating Text Tweet in DB
  #########

  def build_text_tweet(data)
    TextTweet.new(data[:content], data[:tags], data[:id])
  end

  def create_text_tweet(data)
    # Create a text tweet in the db
    data[:id] = @next_tt_id
    @next_tt_id += 1
    @text_tweets[data[:id]] = data
    build_text_tweet(data)
  end

  #########
  # Methods related to creating Tags in DB
  #########

  def get_or_create_tag(data)
    existing_tag = tags.select {|id, tag| tag[:tag] == data[:tag]}.first
    if existing_tag
      data = existing_tag.last
    else
      data[:id] = @next_tag_id
      @next_tag_id += 1
      @tags[data[:id]] = data
    end
    Tag.new(data[:tag], data[:id])
  end

  def get_tag(id)
    data = @tags[id]
    Tag.new(data[:tag], data[:id])
  end

  #########
  # Methods related to the TextTweet to Tag relationship
  #########

  # For creating a text_tweet_tag
  # Expects two inputs: tt_id and tag_id representing the ids of the tweet and 
  # the tag
  # Adds the text_tweet_tag to the database
  # Returns the id of the new text_tweet_tag

  def create_text_tweet_tag(tt_id, tag_id)
    id = @text_tweet_tags_counter
    data = {tt_id: tt_id, tag_id: tag_id, id: id}
    @text_tweet_tags[id] = data
    @text_tweet_tags_counter += 1
    return id
  end

  def get_text_tweets_from_tag(tag)
    new_array = @text_tweet_tags.values.select { |tag_hash| tag_hash[:tag_id] == tag.id }
    new_array.map do |data|
      tt_id = data[:tt_id]
      tt_data = @text_tweets[tt_id]
      Tweet.db.build_text_tweet(tt_data)
    end
  end

  def get_tags_from_text_tweet(text_tweet)
    # TODO: Implement this
  end

  #########
  # Methods related to creating PicTweets
  #########

  def create_pic_tweet(data)
    data[:id] = @pic_tweet_counter
    @pic_tweet_counter += 1

    data[:tags].each do |tag|
      tag_obj = get_or_create_tag({tag: tag})
      create_pic_tweet_tag(data[:id], tag_obj.id)
    end

    @pic_tweets[data[:id]] = data
    
    build_pic_tweet(data)
  end

  # Build a PicTweet out of a data hash
  # Input: A hash
  # Output: A PicTweet object
  def build_pic_tweet(data)
    PicTweet.new(data[:content], data[:pic_url], data[:tags], data[:id])
  end

  #########
  # Methods related to the PicTweet to Tag relationship
  #########

  def create_pic_tweet_tag(pt_id, tag_id)
    id = @pic_tweet_tags_counter
    data = {pt_id: pt_id, tag_id: tag_id, id: id}
    @pic_tweet_tags[id] = data
    @pic_tweet_tags_counter += 1
    return id
  end

  # Input: a tag entity
  # Output: an array of PicTweets with the given tag
  def get_pic_tweets_from_tag(tag)
    new_array = @pic_tweet_tags.values.select { |tag_hash| tag_hash[:tag_id] == tag.id }
    new_array.map do |data|
      pt_id = data[:pt_id]
      pt_data = @pic_tweets[pt_id]
      Tweet.db.build_pic_tweet(pt_data)
    end
  end
end

module Tweet
  def self.db
    @__db_instance ||= DB.new
  end
end

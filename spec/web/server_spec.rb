require 'server_spec_helper'

describe Songify::Server do

  def app
    Songify::Server.new
  end

  describe "GET /" do
    it "loads the homepage" do
      Songify.songs_repo.save_a_song(Songify::Song.new("fake_title", "fake_artist", "fake_album"))
      Songify.songs_repo.save_a_song(Songify::Song.new("fake_title_2", "fake_artist_2", "fake_album_2"))
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include "fake_title", "fake_title_2"
    end
  end

  # describe "GET /" do
  #   it "loads the homepage" do
  #     Bookly.books_repo.save  Bookly::Book.new("My First Book", Date.parse('1983-10-29'))
  #     Bookly.books_repo.save  Bookly::Book.new("My Second Book", Date.parse('1983-10-29'))
  #     get '/'
  #     expect(last_response).to be_ok
  #     expect(last_response.body).to include "My First Book", "My Second Book"
  #   end
  # end

  # describe "POST /books" do
  #   it "creates a book" do
  #     post '/books', { "name" => "My New Book", "published_at" => "1987-06-12" }
  #     expect(last_response).to be_ok

  #     last_book = Bookly.books_repo.all.last
  #     expect(last_response.body).to eq(last_book.name)
  #   end
  # end
end
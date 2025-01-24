# frozen_string_literal: true
module Customer
  class PostsController < PostsController

    self.default_sorts = ["title"]
    self.default_distinct = false

  end
end

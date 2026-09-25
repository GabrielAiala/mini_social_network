require "pagy/extras/metadata"
require "pagy/extras/overflow"

Pagy::DEFAULT[:items_param] = :per_page
Pagy::DEFAULT[:items] = 10
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT[:metadata] = [ :scaffold_url, :page, :pages, :in, :from, :to, :count, :prev_url, :next_url, :first_url, :last_url ]

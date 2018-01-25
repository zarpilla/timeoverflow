require 'spec_helper'

describe Taggable do
  let(:organization) { Fabricate(:organization) }

  let!(:offer) do
    Fabricate(
      :offer,
      organization: organization,
      tags: tags
    )
  end
  let!(:another_offer) do
    Fabricate(
      :offer,
      organization: organization,
      tags: more_tags
    )
  end

  context "class methods and scopes" do
    let(:tags) { %w(foo bar baz) }
    let(:more_tags) { %w(foo baz qux) }

    it "tagged_with" do
      expect(Offer.tagged_with("bar")).to eq [offer]
    end

    it "all_tags" do
      expect(Offer.all_tags).to match_array(tags + more_tags)
    end

    it "find_like_tag" do
      expect(Offer.find_like_tag("foo")).to eq ["foo"]
      expect(Offer.find_like_tag("Foo")).to eq ["foo"]
      expect(Offer.find_like_tag("none")).to eq []
    end
  end

  describe '.alphabetical_grouped_tags' do
    let(:tags) { %w(foo bar baz Boo) }
    let(:more_tags) { %w(foo baz qux) }

    it 'sorts them by alphabetical order case insensitive' do
      expect(Offer.alphabetical_grouped_tags).to eq({
        'B' => [
          Taggable::Tag.new('bar', 1),
          Taggable::Tag.new('baz', 2),
          Taggable::Tag.new('Boo', 1)
        ],
        'F' => [Taggable::Tag.new('foo', 2)],
        'Q' => [Taggable::Tag.new('qux', 1)]
      })
    end
  end
end

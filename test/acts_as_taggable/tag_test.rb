require File.dirname(__FILE__) + '/../test_helper'

class TagTest < ActiveSupport::TestCase
  def test_find_or_create_with_like_by_name
    assert_no_difference 'RedmineCrm::ActsAsTaggable::Tag.count' do
      RedmineCrm::ActsAsTaggable::Tag.find_or_create_with_like_by_name('error')
    end

    assert_difference 'RedmineCrm::ActsAsTaggable::Tag.count', 1 do
      RedmineCrm::ActsAsTaggable::Tag.find_or_create_with_like_by_name('new_tag')
    end
  end

  def test_name_required
    tag = RedmineCrm::ActsAsTaggable::Tag.new
    tag.valid?
    assert_match /blank/, tag.errors[:name].to_s
  end

  def test_name_unique
    tag = RedmineCrm::ActsAsTaggable::Tag.create!(name: 'My tag')
    tag_with_same_name = tag.dup
    assert !tag_with_same_name.valid?
    assert_match /not uniq/, tag_with_same_name.errors[:name].to_s
  end

  def test_taggings
    assert_equivalent [taggings(:tag_for_error), taggings(:tag_for_error1), taggings(:tag_for_error2)], tags(:error).taggings
    assert_equivalent [taggings(:tag_for_question1), taggings(:tag_for_question2), taggings(:tag_for_question3)], tags(:question).taggings
  end

  def test_to_s
    assert_equal tags(:error).name, tags(:error).to_s
  end

  def test_tag_is_equal_to_itself
    tag = tags(:error)
    assert_equal tag, tag
  end

  def test_tag_is_equal_to_tag_with_same_name
    tag = tags(:error)
    assert_equal tag, tag.dup
  end

  def test_tag_is_not_equal_to_tag_with_other_name
    tag = tags(:error)
    other_tag = tag.dup
    other_tag.name = 'not error'
    assert_not_equal tag, other_tag
  end

  def test_taggings_removed_when_tag_destroyed
    assert_difference("RedmineCrm::ActsAsTaggable::Tagging.count", -RedmineCrm::ActsAsTaggable::Tagging.where(tag_id: tags(:error).id).count) do
      assert tags(:error).destroy
    end
  end

  def test_all_counts
    assert_tag_counts RedmineCrm::ActsAsTaggable::Tag.counts, error: 3, feature: 1, bug: 1, question: 3
  end

  def test_all_counts_with_string_conditions
    assert_tag_counts RedmineCrm::ActsAsTaggable::Tag.counts(conditions: 'taggings.created_at >= \'2015-01-01\''),
      question: 3, error: 2, feature: 1, bug: 1
  end

  def test_all_counts_with_array_conditions
    assert_tag_counts RedmineCrm::ActsAsTaggable::Tag.counts(conditions: ['taggings.created_at >= ?', '2015-01-01']),
      question: 3, error: 2, feature: 1, bug: 1
  end
end

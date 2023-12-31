require 'rails_helper'
describe "Visit the show page of 'posts'", type: :feature do
  before :each do
    @user = User.create(name: 'Peter Williams', photo: 'https://randomuser.me/api/portraits/men/32.jpg',
                        bio: 'Hello! I am a QA expert from Scotland.')
    @post = Post.create(author: @user, title: 'Post 2', text: 'This is the content of Post 2')
  end
  it "should display the post's title" do
    visit user_post_path(@user, @post)
    expect(page).to have_content 'Post 2'
  end
  it "should display the post's author" do
    visit user_post_path(@user, @post)
    expect(page).to have_content 'Peter Williams'
  end
  it 'should display how many comments the post has' do
    commentor = User.create(name: 'Edward Richards')
    Comment.create(post: @post, author: commentor, text: 'This is the first comment on Post 2')
    Comment.create(post: @post, author: commentor, text: 'This is the second comment on Post 2')
    visit user_post_path(@user, @post)
    expect(page).to have_content 'Comments: 2, Likes: 0'
  end
  it 'should display how many likes the post has' do
    Like.create(post: @post, author: @user)
    visit user_post_path(@user, @post)
    expect(page).to have_content 'Comments: 0, Likes: 1'
  end
  it 'should display the body of the post' do
    visit user_post_path(@user, @post)
    expect(page).to have_content 'This is the content of Post 2'
  end
  it 'should display the username and comment of each commentor' do
    commentor1 = User.create(name: 'Edward')
    commentor2 = User.create(name: 'Roger')
    Comment.create(post: @post, author: commentor1, text: 'This is the first comment on Post 2')
    Comment.create(post: @post, author: commentor2, text: 'This is the second comment on Post 2')
    visit user_post_path(@user, @post)
    expect(page).to have_content 'Edward'
    expect(page).to have_content 'This is the first comment on Post 2'
    expect(page).to have_content 'Roger'
    expect(page).to have_content 'This is the second comment on Post 2'
  end
  it 'Clicking on the Like button should increase the number of likes of the post' do
    visit user_post_path(@user, @post)
    expect(page).to have_content 'Comments: 0, Likes: 0'
    click_button 'Like it'
    expect(page).to have_content 'Comments: 0, Likes: 1'
  end
  it "Clicking on the Don't Like it button should decrease the number of likes of the post" do
    Like.create(post: @post, author: @user)
    visit user_post_path(@user, @post)
    expect(page).to have_content 'Comments: 0, Likes: 1'
    click_button "Don't Like it"
    expect(page).to have_content 'Comments: 0, Likes: 0'
  end
  it "Clicking on the Create a Comment button should redirect to comment's new page" do
    visit user_post_path(@user, @post)
    click_link 'Create a Comment'
    expect(page).to have_current_path(new_user_post_comment_path(@user, @post))
  end
end

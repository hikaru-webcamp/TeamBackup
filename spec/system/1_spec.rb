require 'rails_helper'

describe '登録のテスト' do
  let!(:admin) { create(:admin) }
  #@admin = FactoryBot.create(:admin)

  before do
    visit new_admin_session_path #visitは指定したパスへの画面遷移を行います。
    #fill_inではフォームにテキストを入力します。with:のあとには入力したい文字列を指定します。
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end

  #expect(current_path)で現在のページURLを期待値としています。
  #eqは指定した値が期待値と同値であるかを判定します。
  #簡単にいうと今いるページが admin_orders_pathと同値であるか。
  context '管理者ログインのテスト' do
    it 'ログイン後、管理者トップ（注文履歴一覧）が表示される' do
      expect(current_path).to eq admin_root_path
    end
  end

 #expect(page)で遷移中のページ全体を期待値としています。
  #have_linkではページの中に文字列にマッチするリンク
  context '管理者トップ画面のテスト' do
    it 'ログイン後、ヘッダーにジャンル一覧のリンクが表示されている' do
      expect(page).to have_link 'ジャンル一覧'
    end
  #ジャンル一覧をクリックして、現在いるページがadmin_genres_pathと同値であるか。
    it 'ジャンル一覧のリンクを押すとジャンル一覧画面が表示される' do
      click_link 'ジャンル一覧'
      expect(current_path).to eq admin_genres_path
    end
  end

  context 'ジャンル一覧画面のテスト' do
    before do
      visit admin_genres_path
    end

    it '必要事項を入力し、登録ボタンを押すと追加したジャンルが表示される' do
      fill_in 'genre[name]', with: 'ケーキ'
      click_button '新規登録'
      #have_contentでは指定の値がページ内に含まれているか確認。今回の場合ページ内に”ケーキ”という文字列を指定
      expect(page).to have_content 'ケーキ'
    end

    it '商品一覧のリンクを押すと商品一覧画面が表示される' do
      click_link '商品一覧'
      expect(current_path).to eq admin_products_path
    end
  end

  context '商品一覧画面のテスト' do
    before do
      visit admin_products_path
    end
     it '新規登録ボタンを押すと商品新規登録画面が表示される' do
      visit new_admin_product_path
      expect(current_path).to eq new_admin_product_path
    end
  end

	context '商品新規登録画面のテスト' do
    let!(:genre) { create(:genre) }
    #@genre = FactoryBot.create(:genre)
    before do
      visit new_admin_product_path
    end

    it '必要事項を入力して登録ボタンを押すと登録した商品の詳細画面が表示される' do
      attach_file 'product[image]', "#{Rails.root}/app/assets/images/top_image.jpg"
      fill_in 'product[name]', with: 'いちごのケーキ(ホール)'
      fill_in 'product[introduction]', with: '高級いちごを贅沢に使用しています'
      select genre.name, from: 'product[genre_id]'
      fill_in 'product[price]', with: 3000
      click_button '送信'
      expect(page).to have_content '商品詳細'
      expect(page).to have_content 'いちごのケーキ(ホール)'
    end
  end

  context '商品詳細画面のテスト' do
    let!(:genre) { create(:genre) }
    let!(:product) { create(:product) }

    before do
      visit admin_product_path(product)
    end

    it 'ヘッダーに「商品一覧」というリンクがある' do
      expect(page).to have_link '商品一覧'
    end

    it '「商品一覧」のリンクを押すと商品一覧画面が表示される' do
      click_link '商品一覧'
      expect(current_path).to eq admin_products_path
    end
  end

context '商品一覧画面(1商品登録後)のテスト' do
    let!(:genre) { create(:genre) }
    let!(:product) { create(:product) }

    before do
      visit admin_products_path
    end

    it '登録した商品が表示されている' do
      expect(page).to have_content product.name
      expect(page).to have_content product.price
      expect(page).to have_content product.genre.name
      expect(page).to have_content "販売中"
    end

    it '「商品作成はこちら」というリンクを押すと商品新規登録画面が表示される' do
      click_link '商品作成はこちら'
      expect(current_path).to eq new_admin_product_path
    end
  end

  context '商品新規登録(2商品目)のテスト' do
    let!(:genre) { create(:genre) }
    let!(:product) { create(:product) }

    before do
      visit new_admin_product_path
    end

    it '必要事項を入力して登録ボタンを押すと登録した商品の詳細画面が表示される' do
      attach_file 'product[image]', "#{Rails.root}/app/assets/images/strawberry-cake.jpg"
      fill_in 'product[name]', with: 'りんごのケーキ(ホール)'
      fill_in 'product[introduction]', with: '高級りんごを使用しています'
      select genre.name, from: 'product[genre_id]'
      fill_in 'product[price]', with: 2500
      click_button '送信'
      expect(page).to have_content '商品詳細'
      expect(page).to have_content 'りんごのケーキ(ホール)'
    end
  end

  context '商品詳細画面(2商品登録後)のテスト' do
    let!(:genre) { create(:genre) }
    let!(:product_1) { create(:product) }
    let!(:product_2) { create(:product) }

    before do
      visit admin_product_path(product_2)
    end

    it 'ヘッダーに「商品一覧」というリンクがある' do
      expect(page).to have_link '商品一覧'
    end

    it '「商品一覧」のリンクを押すと商品一覧画面が表示される' do
      click_link '商品一覧'
      expect(current_path).to eq admin_products_path
    end
  end

  context '商品一覧画面(2商品登録後)のテスト' do
    let!(:genre) { create(:genre) }
    let!(:product_1) { create(:product) }
    let!(:product_2) { create(:product) }

    before do
      visit admin_products_path
    end

    it '登録した商品が2つとも表示されている' do
      expect(page).to have_content product_1.name
      expect(page).to have_content product_1.price
      expect(page).to have_content product_1.genre.name
      expect(page).to have_content "販売中"
      expect(page).to have_content product_2.name
      expect(page).to have_content product_2.price
      expect(page).to have_content product_2.genre.name
      expect(page).to have_content "販売中"
    end

    it 'ログアウト」リンクを押すと管理者ログイン画面に遷移する' do
      click_link 'ログアウト'
      expect(current_path).to eq new_admin_session_path
    end
  end
end
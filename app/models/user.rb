class User < ActiveRecord::Base
	before_save { self.email = self.email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	validates :location, presence: true, inclusion: { in: %w(北海道 青森県 岩手県 宮城県 秋田県 山形県 福島県 茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県 新潟県 富山県 石川県 福井県 山梨県 長野県 岐阜県 静岡県 愛知県 三重県 滋賀県 京都府 大阪府 兵庫県 奈良県 和歌山県 鳥取県 島根県 岡山県 広島県 山口県 徳島県 香川県 愛媛県 高知県 福岡県 佐賀県 長崎県 熊本県 大分県 宮崎県 鹿児島県 沖縄県) }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255 },
	                  format: { with: VALID_EMAIL_REGEX }, 
	                  uniqueness: { case_sensitive: false }
	has_secure_password
	
	has_many :microposts
	
	#フォローとフォロワーの取得（has_many〜through）
	has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
    has_many :following_users, through: :following_relationships, source: :followed
	
	has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
    has_many :follower_users, through: :follower_relationships, source: :follower
	
	#followingで取得した集合を取り扱いやすくする
	#他のユーザーをフォローする            
	def follow(other_user)
		following_relationships.find_or_create_by(followed_id: other_user.id)
	end
	
	#フォローしているユーザーをアンフォローする
	def unfollow(other_user)
		following_relationship = following_relationships.find_by(followed_id: other_user.id)
		following_relationship.destroy if following_relationship
	end
	
	#あるユーザーをフォローしているかどうか？
	def following?(other_user)
		following_users.include?(other_user)
	end
	
end
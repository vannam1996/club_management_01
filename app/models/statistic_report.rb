class StatisticReport < ApplicationRecord
  belongs_to :club, required: true
  belongs_to :user, required: true

  validates :style, presence: true
  validates :item_report, presence: true
  validates :detail_report, presence: true
  validates :plan_next_month, presence: true
  validates :time, presence: true
  validates :time, uniqueness: {scope: :club_id}

  enum style_statistic: {monthly: 1, quarterly: 2}
  enum month: {january: 1, febuary: 2, march: 3, april: 4,
    may: 5, june: 6, july: 7, august: 8, september: 9,
    october: 10, november: 11, december: 12}
  enum quarter: {quarter_1: 13, quarter_2: 14, quarter_3: 15, quarter_4: 16}
end

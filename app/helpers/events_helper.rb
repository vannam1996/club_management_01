module EventsHelper
  def number_to_vnd amount
    raw "#{amount} <sup>vnđ</sup>"
  end

  def view_case_money_after event
    if event.subsidy?
      event.amount.to_i + event.expense.to_i
    elsif event.pay_money?
      event.amount.to_i - event.expense.to_i
    elsif event.get_money?
      event.amount.to_i + (@members_done.size.to_i * event.expense.to_i)
    end
  end

  def view_notification event
    case event.event_category
    when Settings.get_money
      t("after_get_money")
    when Settings.pay_money
      t("after_pay_money")
    when Settings.subsidy
      t("after_receive_money")
    else
      t("notification_event")
    end
  end

  def view_case_money_event_after event, club
    members_done = club.users.done_by_ids(event.budgets.map(&:user_id))
    case when event.get_money?
      after_money = event.amount.to_i + (members_done.size.to_i * event.expense.to_i)
    when event.pay_money?
      after_money = event.amount.to_i - event.expense.to_i
    when event.subsidy?
      after_money = event.amount.to_i + event.expense.to_i
    when event.donate?
      after_money = event.amount.to_i + event.expense.to_i
    else
      after_money = nil
    end
    after_money
  end

  def view_class event
    event.pay_money? ? "text-primary" : "text-success"
  end

  def view_icon event
    if event.pay_money?
      html = <<-HTML
        <i class="fa fa-minus get-money-icon" aria-hidden="true"></i>
      HTML
    else
      html = <<-HTML
        <i class="fa fa-plus pay-money-icon" aria-hidden="true"></i>
      HTML
    end
    raw html
  end

  def count_member_done event, club
    members_done = club.users.done_by_ids(event.budgets.map(&:user_id))
    html =
      <<-HTML
        (#{members_done.size} <i class="fa fa-user-o" aria-hidden="true"></i>)
      HTML
    raw html
  end

  def get_money_expense event, club
    event.expense * event.budgets.size
  end

  def category_event
    [[t("subsidy"), Event.event_categories[:subsidy]],
    [t("get_money"), Event.event_categories[:get_money]],
    [t("notification"), Event.event_categories[:notification]],
    [t("pay_money"), Event.event_categories[:pay_money]],
    [t("donate.donate"), Event.event_categories[:donate]]]
  end

  def confirm_donate donate, club
    if donate.accept?
      html = <<-HTML
        <span class="btn btn-success">#{t("donate.confirmed")}</span>
      HTML
      raw html
    elsif club.is_admin? current_user
      link_to t("donate.wait_confirmation"),
        edit_club_event_donate_path(club, donate.event_id, donate, status: :accept),
        remote: :true, class: "btn btn-breez", title: t("confirm")
    else
      html = <<-HTML
        <span class="btn btn-breez">#{t("donate.wait_confirmation")}</span>
      HTML
      raw html
    end
  end
end

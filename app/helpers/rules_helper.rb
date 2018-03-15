module RulesHelper
  def is_action_edit? action
    action == Settings.edit
  end

  def label_button_submit action
    if is_action_edit? action
      t "form_rule.btn_update"
    else
      t "form_rule.btn_create"
    end
  end

  def value_mark_field rule_detail
    rule_detail.id.present? ? rule_detail.points : Settings.default_number_field
  end
end

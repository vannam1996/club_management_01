module EvaluatesHelper
  def get_and_group_rule_details evaluate
    rule_detail_ids = evaluate.evaluate_details.pluck(:rule_detail_id)
    rule_details = RuleDetail.includes(:rule).by_ids(rule_detail_ids)
    rule_details.group_by &:rule_id
  end

  def note_evaluate_detail evaluate, rule_detail
    return unless evaluate.id
    details = evaluate.evaluate_details
      .select{|detail| detail.rule_detail_id == rule_detail.id}
    if details.present?
      details.first.note
    else
      ""
    end
  end

  def size_row_span rule_details
    rule_details.size
  end

  def is_have_in_evaluate_details? evaluate, action, rule_detail
    return unless evaluate.id
    evaluate.evaluate_details.pluck(:rule_detail_id).include? rule_detail.id
  end

  def class_checkbox evaluate, action, rule_detail
    Settings.class_check_box_checked if is_have_in_evaluate_details? evaluate, action, rule_detail
  end

  def total_point evaluate
    return unless evaluate.id
    evaluate.total_points
  end

  def label_submit action
    if action == Settings.edit
      t ".update"
    else
      t ".submit"
    end
  end
end

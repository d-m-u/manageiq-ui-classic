class ApplicationHelper::Button::UtilizationDownload < ApplicationHelper::Button::Basic
  def disabled?
    # to enable the button we
    # b) we are in the "Utilization" and have trend report
    return false if @layout == 'miq_capacity_utilization' && @sb[:active_tab] == 'report' && !@sb.fetch_path(:trend_rpt).table.data.empty?

    # c) we are in the "Bottlenecks" on 'Report' tab and have report data available
    return false if @layout == 'miq_capacity_bottlenecks' && @sb[:active_tab] == 'report' && !@sb[:report].table.data.empty?

    # otherwise the button is off
    @error_message = _('No records found for this report')
    @error_message.present?
  end
end

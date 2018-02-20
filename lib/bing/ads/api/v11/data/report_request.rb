module Bing
  module Ads
    module API
      module V11
        module Data
          # Bing::Ads::API::V11::Data::ReportRequest
          class ReportRequest

            # @order
            # https://msdn.microsoft.com/en-us/library/bing-ads-reporting-reportrequest.aspx
            KEYS_ORDER = [
              :exclude_column_headers,
              :exclude_report_footer,
              :exclude_report_header,
              :format,
              :language,
              :report_name,
              :return_only_complete_data,
              :aggregation,
              :columns,
              :filter,
              :scope,
              :time
            ]

            class << self
              def prepare(type, report_request_raw)
                if report_request_raw[:account_ids].nil?
                  scope = nil
                else
                  scope = {'ins0:AccountIds' => {'ins0:long' => report_request_raw[:account_ids]}}
                end
                
                namespace_identifier = Bing::Ads::API::V11::NAMESPACE_IDENTIFIER
                {report_request:
                  {
                    :'@xsi:type' => "#{namespace_identifier}:#{type.to_s.classify}ReportRequest",
                    :ExcludeColumnHeaders => report_request_raw[:exclude_column_headers],
                    :ExcludeReportFooter => report_request_raw[:exclude_report_footer],
                    :ExcludeReportHeader => report_request_raw[:exclude_report_header],
                    :Format => report_request_raw[:format],
                    :Language => report_request_raw[:language],
                    :ReportName => report_request_raw[:report_name],
                    :ReturnOnlyCompleteData => report_request_raw[:return_only_complete_data],
                    :Aggregation => report_request_raw[:aggregation],
                    :Columns =>  prepare_columns(
                                         columns: report_request_raw[:columns],
                                         type: type.to_s.classify
                                       ),
                    :Filter => nil,
                    :Scope => scope,
                    :Time => prepare_time_period(
                      from_date: report_request_raw[:from_date],
                      to_date:   report_request_raw[:to_date]
                    )
                  }
                }
              end

              private

              def prepare_columns(type:, columns:)
                {
                  "#{type}ReportColumn" => columns.map(&:to_s).map(&:camelcase)
                }
              end

              def prepare_time_period(from_date:, to_date:)
                from_date = Date.parse(from_date)
                to_date = Date.parse(to_date)

                {
                  custom_date_range_end: {
                    day: to_date.day,
                    month: to_date.month,
                    year: to_date.year
                  },
                  custom_date_range_start: {
                    day: from_date.day,
                    month: from_date.month,
                    year: from_date.year
                  }
                }
              end
            end
          end
        end
      end
    end
  end
end

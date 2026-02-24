
view: nusaiba1 {
  derived_table: {
    sql: {% raw %} /*
      -- Ticket: https://vidahealth.atlassian.net/browse/BIHA-368
      -- The total revenue from all Revenue models for a given calendar month
      
      All Revenue Models currently (1/2026) include:
        pppm_program_standard
        pppm_program_engagement
        pppm_health_condition
        pppm_tier
        case_rate
        ffs
        pepm
      
      This metric captures total revenue billed in a given invoice calendar month
      */
      select 
      
        date_trunc(date(invoice_period_started_at), month) as year_month,
      
        sum(ifnull(billable_revenue_for_invoice_period, 0)) as total_billable_revenue_for_invoice_period
      
      from `dbt-vida.dbt.consolidated_billing__final` billing
      inner join `dbt-vida.dbt.dim_member` member
        on billing.member_uuid = member.member_uuid
      where 1=1
        and not member.is_tester
      group by 1 
      order by 1 desc {% endraw %} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: year_month {
    type: date
    datatype: date
    sql: ${TABLE}.year_month ;;
  }

  dimension: total_billable_revenue_for_invoice_period {
    type: number
    sql: ${TABLE}.total_billable_revenue_for_invoice_period ;;
  }

  set: detail {
    fields: [
        year_month,
	total_billable_revenue_for_invoice_period
    ]
  }
}

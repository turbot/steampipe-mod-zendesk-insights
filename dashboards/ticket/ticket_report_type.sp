dashboard "ticket_type_report" {
  title = "Zendesk Ticket Type Report"
  documentation = file("./dashboards/ticket/docs/ticket_report_type.md")

  tags = merge(local.ticket_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.ticket_total_count
      width = 2
    }

    card {
      query = query.ticket_type_incident_count
      width = 2
    }

    card {
      query = query.ticket_type_problem_count
      width = 2
    }

    card {
      query = query.ticket_type_question_count
      width = 2
    }

    card {
      query = query.ticket_type_task_count
      width = 2
    }
  }

  container {
    table {
      title = "Ticket Types by Year"
      query = query.ticket_type_year_table
    }
  }
}

query "ticket_type_incident_count" {
  sql = <<-EOQ
    select count(*) as "Incident" from zendesk_ticket where type = 'incident';
  EOQ
}

query "ticket_type_problem_count" {
  sql = <<-EOQ
    select count(*) as "Problem" from zendesk_ticket where type = 'problem';
  EOQ
}

query "ticket_type_question_count" {
  sql = <<-EOQ
    select count(*) as "Question" from zendesk_ticket where type = 'question';
  EOQ
}

query "ticket_type_task_count" {
  sql = <<-EOQ
    select count(*) as "Task" from zendesk_ticket where type = 'task';
  EOQ
}

query "ticket_type_year_table" {
  sql = <<-EOQ
    select
      type as "Type",
      date_part('year',created_at) as "Year",
      count(*) as "Count"
    from
      zendesk_ticket
    group by
      date_part('year',created_at), type
    order by
      "Year", "Type";
  EOQ
}
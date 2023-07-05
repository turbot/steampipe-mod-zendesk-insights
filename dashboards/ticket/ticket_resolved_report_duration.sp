dashboard "ticket_resolved_duration_report" {
  title = "Zendesk Resolved Ticket Duration Report"
  documentation = file("./dashboards/ticket/docs/ticket_unsolved_report_age.md")

  tags = merge(local.ticket_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.ticket_resolved_count
      width = 2
    }

    card {
      query = query.ticket_resolved_incident_average_duration
      width = 2
    }

    card {
      query = query.ticket_resolved_problem_average_duration
      width = 2
    }

    card {
      query = query.ticket_resolved_question_average_duration
      width = 2
    }

    card {
      query = query.ticket_resolved_task_average_duration
      width = 2
    }
  }

  container {
    table {
      title = "Resolved Tickets"
      query = query.ticket_resolved_table

      column "url" {
        display = "none"
      }

      column "org_url" {
        display = "none"
      }

      column "Ticket" {
        href = "{{.'url'}}"
      }

      column "Organization" {
        href = "{{.'org_url'}}"
      }
    }
  }
}

query "ticket_resolved_incident_average_duration" {
  sql = <<-EOQ
    select avg(updated_at::date - created_at::date) as "Incident Average Duration (days)" from zendesk_ticket where type = 'incident';
  EOQ
}

query "ticket_resolved_problem_average_duration" {
  sql = <<-EOQ
    select avg(updated_at::date - created_at::date) as "Problem Average Duration (days)" from zendesk_ticket where type = 'problem';
  EOQ
}

query "ticket_resolved_question_average_duration" {
  sql = <<-EOQ
    select avg(updated_at::date - created_at::date) as "Question Average Duration (days)" from zendesk_ticket where type = 'question';
  EOQ
}

query "ticket_resolved_task_average_duration" {
  sql = <<-EOQ
    select avg(updated_at::date - created_at::date) as "Task Average Duration (days)" from zendesk_ticket where type = 'task';
  EOQ
}

query "ticket_resolved_table" {
  sql = <<-EOQ
    select
      o.name as "Organization",
      t.id || ' ' || t.subject as "Ticket",
      t.type as "Type",
      t.status as "Status",
      t.created_at as "Created Date",
      t.updated_at as "Last Updated Date",
      t.updated_at::date - t.created_at::date as "Duration",
      o.url as org_url,
      t.url
    from
      zendesk_ticket t
    left outer join
      zendesk_organization o
    on
      t.organization_id = o.id
    where
      status in ('solved', 'closed')
    order by
      "Duration" desc;
  EOQ
}
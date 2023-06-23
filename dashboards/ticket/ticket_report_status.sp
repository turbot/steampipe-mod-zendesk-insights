dashboard "ticket_status_report" {
  title = "Zendesk Ticket Status Report"
  documentation = file("./dashboards/ticket/docs/ticket_report_status.md")

  tags = merge(local.ticket_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.ticket_total_count
      width = 2
    }

    card {
      query = query.ticket_status_new_count
      width = 2
      type  = "info"
    }

    card {
      query = query.ticket_status_open_count
      width = 2
      type  = "info"
    }

    card {
      query = query.ticket_status_pending_count
      width = 2
      type  = "info"
    }

    card {
      query = query.ticket_status_hold_count
      width = 2
      type  = "info"
    }

    card {
      query = query.ticket_status_solved_closed_count
      width = 2
      type  = "info"
    }
  }

  container {
    table {
      title = "Ticket Statuses"
      query = query.ticket_status_table

      column "url" {
        display = "none"
      }

      column "weight" {
        display = "none"
      }

      column "Ticket" {
        href = "{{.'url'}}"
      }
    }
  }
}

query "ticket_status_new_count" {
  sql = <<-EOQ
    select
      'New' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status = 'new';
  EOQ
}

query "ticket_status_open_count" {
  sql = <<-EOQ
    select
      'Open' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status = 'open';
  EOQ
}

query "ticket_status_pending_count" {
  sql = <<-EOQ
    select
      'Pending' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status = 'pending';
  EOQ
}

query "ticket_status_hold_count" {
  sql = <<-EOQ
    select
      'Hold' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status = 'hold';
  EOQ
}

query "ticket_status_solved_closed_count" {
  sql = <<-EOQ
    select
      'Solved / Closed' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status in ('solved', 'closed');
  EOQ
}

query "ticket_status_table" {
  sql = <<-EOQ
    select
      id || ' ' || subject as "Ticket",
      status as "Status",
      case status
        when 'new' then 0
        when 'open' then 1
        when 'pending' then 2
        when 'hold' then 3
        when 'solved' then 4
        when 'closed' then 5
      end as weight,
      priority as "Priority",
      date_part('day', now() - created_at) as "Age in days",
      url
    from
      zendesk_ticket
    order by
      weight asc, "Age in days" desc;
  EOQ
}
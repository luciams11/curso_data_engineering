{% test checking_dates(model, date1, date2) %}

   select *
   from {{ model }}
   where {{ date1 }} < {{ date2 }}
   and {{ date2 }} is not null

{% endtest %}
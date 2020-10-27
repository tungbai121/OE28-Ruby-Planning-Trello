Ransack.configure do |config|

  # Change default search parameter key name.
  # Default key name is :q
  config.search_key = :q

  # Raise errors if a query contains an unknown predicate or attribute.
  # Default is true (do not raise error on unknown conditions).
  config.ignore_unknown_conditions = false

  # Globally display sort links without the order indicator arrow.
  # Default is false (sort order indicators are displayed).
  # This can also be configured individually in each sort link (see the README).
  config.hide_sort_order_indicators = false

  config.custom_arrows = {
    up_arrow: "<i class='fas fa-sort-up'></i>",
    down_arrow: "<i class='fas fa-sort-down'></i>",
    default_arrow: "<i class='fas fa-sort'></i>"
  }

  Ransack.configure do |config|
    config.add_predicate "date_equals",
      arel_predicate: "eq",
      formatter: proc { |v| v.to_date },
      validator: proc { |v| v.present? },
      type: :string
  end
end

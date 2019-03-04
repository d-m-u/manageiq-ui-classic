class TreeBuilderOpsVmdb < TreeBuilderOps
  has_kids_for VmdbTableEvm, %i(x_get_tree_vmdb_table_kids options)

  private

  def tree_init_options
    {:open_all => false}
  end

  def set_locals_for_render
    locals = super
    locals.merge!(:autoload => true)
  end

  def root_options
    {
      :text    => t = _("VMDB"),
      :tooltip => t,
      :icon    => 'fa fa-database'
    }
  end

  # Get root nodes count/array for explorer tree
  def x_get_tree_roots(count_only, _options)
    objects = Rbac.filtered(VmdbDatabase.my_database.try(:evm_tables).to_a).to_a
    count_only_or_objects(count_only, objects, "name")
  end

  # Handle custom tree nodes (object is a Hash)
  def x_get_tree_custom_kids(object, count_only, _options)
    vmdb_table_id = object[:id].split("|").last.split('-').last
    vmdb_indexes  = VmdbIndex.includes(:vmdb_table).where(:vmdb_tables => {:type => 'VmdbTableEvm', :id => vmdb_table_id})
    count_only_or_objects(count_only, vmdb_indexes, "name")
  end

  def x_get_tree_vmdb_table_kids(object, count_only, options)
    if count_only
      1 # each table has any index
    else
      # load this node expanded on autoload
      options[:open_nodes].push("xx-#{object.id}") unless options[:open_nodes].include?("xx-#{object.id}")
      [
        {
          :id            => object.id.to_s,
          :text          => _("Indexes"),
          :icon          => "pficon pficon-folder-close",
          :tip           => _("Indexes"),
          :load_children => true
        }
      ]
    end
  end
end

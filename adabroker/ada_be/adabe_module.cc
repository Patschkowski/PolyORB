#include <adabe.h>
 
static string remove_dot(string  name)
{
  char c;
  while ((c = name.find(".")) != -1) 
    name[c]='-';
  return name;

}

adabe_module::adabe_module(UTL_ScopedName *n, UTL_StrList *p)
                 : AST_Decl(AST_Decl::NT_module, n, p),
		   UTL_Scope(AST_Decl::NT_module),
                   adabe_name(AST_Decl::NT_module, n, p) 
{
}
void
adabe_module::produce_ads(dep_list& with,string &body, string &previousdefinition)
{
  
  // before doing anything compute the ada name
  
  compute_ada_name(); 
  bool first = true;
  
  // For each declaration in the node produce the code
  
  UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      module_activator.next();
      adabe_global::set_adabe_current_file(this);
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_pre_defined:
	case AST_Decl::NT_const:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	  if (first) {
	    body = "Package " + get_ada_full_name()+ " is\n";
	    first = false;    
	  }
	  previousdefinition += body;
	  body ="";
	case AST_Decl::NT_interface_fwd:
	  dynamic_cast<adabe_name *>(d)->produce_ads(with, body, previousdefinition);
	  break;
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous = "";
	    string module_body = "";
	    string module_with_string;
	    dep_list module_with;
	    
	    module->produce_ads(module_with,module_body,module_previous);
	    module_with_string = *module_with.produce("with ");
	    
	    string module_file_name =
	      remove_dot(module->get_ada_full_name()) + ".ads";
	    char *lower_case_name = lower(module_file_name.c_str());
	    ofstream module_file(lower_case_name); 
	    delete[] lower_case_name;
	    module_file << module_with_string;
	    module_file << module_previous;
	    module_file << module_body;
	    module_file.close();
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_ads(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name())+ ".ads";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  break;
	case AST_Decl::NT_enum_val:
	  break;

	default:
	  throw adabe_internal_error(__FILE__,__LINE__,"unexpected contening scope");
	  break;
	}
    }
  if (!first) {
    body += "end " + get_ada_full_name() + " ;";
  }

}

void
adabe_module::produce_adb(dep_list& with,string &body, string &previousdefinition)
  // does nothing except lauching produce adb for the interfaces
{
   UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      module_activator.next();
      adabe_global::set_adabe_current_file(this);
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_interface_fwd:
	case AST_Decl::NT_pre_defined:
	case AST_Decl::NT_const:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	  break;
	    
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous = "";
	    string module_body = "";
	    dep_list module_with;
	    
	    module->produce_adb(module_with,module_body,module_previous);
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_adb(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name()) + ".adb";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  
	  break;
	default:
	  break;
	}
    }
}

void
adabe_module::produce_impl_ads(dep_list& with,string &body, string &previousdefinition)
  // does nothing except lauching produce imp_ads for the interfaces
{
   UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      module_activator.next();
      adabe_global::set_adabe_current_file(this);
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_interface_fwd:
	case AST_Decl::NT_pre_defined:
	case AST_Decl::NT_const:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	  break;
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous = "";
	    string module_body = "";
	    dep_list module_with;
	    
	    module->produce_impl_ads(module_with,module_body,module_previous);
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_impl_ads(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name()) + "-impl.ads";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  
	  break;
	default:
	  break;
	}
    }
}
void
adabe_module::produce_impl_adb(dep_list& with,string &body, string &previousdefinition)
  // does nothing except lauching produce adb for the interfaces
{
   UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      module_activator.next();
      adabe_global::set_adabe_current_file(this);
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_interface_fwd:
	case AST_Decl::NT_pre_defined:
	case AST_Decl::NT_const:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	  break;
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous = "";
	    string module_body = "";
	    dep_list module_with;
	    
	    module->produce_impl_adb(module_with,module_body,module_previous);
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_impl_adb(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name()) + "-impl.adb";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  
	  break;
	default:
	  break;
	}
    }
}



void
adabe_module::produce_proxies_ads(dep_list& with,string &body, string &previousdefinition)
  // does nothing except lauching produce imp_ads for the interfaces
{
   UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      adabe_global::set_adabe_current_file(this);
      module_activator.next();
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_interface_fwd:
	case AST_Decl::NT_pre_defined:
	case AST_Decl::NT_const:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	  break;
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous = "";
	    string module_body = "";
	    dep_list module_with;
	    
	    module->produce_proxies_ads(module_with,module_body,module_previous);
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_proxies_ads(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name()) + "-proxies.ads";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  
	  break;
	default:
	  break;
	}
    }
}

void
adabe_module::produce_proxies_adb(dep_list& with,string &body, string &previousdefinition)
  // does nothing except lauching produce adb for the interfaces
{
   UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      adabe_global::set_adabe_current_file(this);
      module_activator.next();
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_interface_fwd:
	case AST_Decl::NT_pre_defined:
	case AST_Decl::NT_const:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	  break;
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous = "";
	    string module_body = "";
	    dep_list module_with;
	    
	    module->produce_proxies_adb(module_with,module_body,module_previous);
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_proxies_adb(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name()) + "-proxies.adb";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  
	  break;
	default:
	  break;
	}
    }
}

void
adabe_module::produce_skel_ads(dep_list& with,string &body, string &previousdefinition)
  // does nothing except lauching produce imp_ads for the interfaces
{
   UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      adabe_global::set_adabe_current_file(this);
      module_activator.next();
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_interface_fwd:
	case AST_Decl::NT_pre_defined:
	case AST_Decl::NT_const:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	  break;
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous = "";
	    string module_body = "";
	    dep_list module_with;
	    
	    module->produce_skel_ads(module_with,module_body,module_previous);
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_skel_ads(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name()) + "-skeleton.ads";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  
	  break;
	default:
	  break;
	}
      if (!true) {
	body += "end " + get_ada_full_name();
      }
    }
}

void
adabe_module::produce_skel_adb(dep_list& with,string &body, string &previousdefinition)
  // does nothing except lauching produce adb for the interfaces
{
   UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      adabe_global::set_adabe_current_file(this);
      module_activator.next();
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_interface_fwd:
	case AST_Decl::NT_pre_defined:
	case AST_Decl::NT_const:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	  break;
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous = "";
	    string module_body = "";
	    dep_list module_with;
	    
	    module->produce_skel_adb(module_with,module_body,module_previous);
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_skel_adb(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name()) + "-skeleton.adb";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  
	  break;
	default:
	  break;
	}
      if (!true) {
	body += "end " + get_ada_full_name() + " ;";
      }
    }
}

void
adabe_module::produce_marshal_ads(dep_list& with,string &body, string &previousdefinition)
{ 
  body += "use type Corba.Unsigned_Long; \n";
  body += "with NetbufferedStream ; use NetbufferedStream ;\n";
  body += "with MembufferedStream ; use MembufferedStream ;\n";
  with.add ("Giop_C");
  with.add ("Corba");

  bool first = true;
  
  // For each declaration in the node produce the code
  
  UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      module_activator.next();
      adabe_global::set_adabe_current_file(this);
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	case AST_Decl::NT_string:
	  if (first) {
	    body += "Package " + get_ada_full_name() + ".marshal is\n";
	    first = false;
	  }
	  dynamic_cast<adabe_name *>(d)->produce_marshal_ads(with, body, previousdefinition);
	  break;
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous = "";
	    string module_body = "";
	    string module_with_string;
	    dep_list module_with;
	    
	    module->produce_marshal_ads(module_with,module_body,module_previous);
	    module_with_string = *module_with.produce("with ");
	    
	    string module_file_name =
	      remove_dot(module->get_ada_full_name()) + "-marshal.ads";
	    char *lower_case_name = lower(module_file_name.c_str());
	    ofstream module_file(lower_case_name); 
	    delete[] lower_case_name;
	    module_file << module_with_string;
	    module_file << module_previous;
	    module_file << module_body;
	    module_file.close();
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_marshal_ads(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name()) + "-marshal.ads";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  break;

	default:
	  break;
	}
    }
  if (!first) {
    body += "end " + get_ada_full_name() + ".marshal ;";
  }

}

void
adabe_module::produce_marshal_adb(dep_list& with,string &body, string &previousdefinition)
  // does nothing except lauching produce adb for the interfaces
{

  bool first = true;

  UTL_ScopeActiveIterator module_activator(this,UTL_Scope::IK_decls);
  while (!module_activator.is_done())
    {
      AST_Decl *d = module_activator.item();
      adabe_global::set_adabe_current_file(this);
      module_activator.next();
      switch(d->node_type())
	{
	case AST_Decl::NT_array:
	case AST_Decl::NT_except:
	case AST_Decl::NT_union:
	case AST_Decl::NT_struct:
	case AST_Decl::NT_enum:
	case AST_Decl::NT_typedef:
	case AST_Decl::NT_string:
	  if (first == true)
	    {
	      body += "Package body " + get_ada_full_name() + ".marshal is \n";
	      first = false;
	    }
	  previousdefinition += body;
	  body = "";
	  dynamic_cast<adabe_name *>(d)->produce_marshal_adb(with, body, previousdefinition);
	  break;
	    
	case AST_Decl::NT_module:
	  {
	    adabe_module *module = adabe_module::narrow_from_decl(d);
	    string module_previous     = "";
	    string module_body         = "";
	    string module_with_string  = "";
	    dep_list module_with;
	    
	    module->produce_marshal_adb(module_with,module_body,module_previous);
	    module_with_string = *module_with.produce("with ");
	    
	    string module_file_name =
	      remove_dot(module->get_ada_full_name()) + "-marshal.adb";
	    char *lower_case_name = lower(module_file_name.c_str());
	    ofstream module_file(lower_case_name); 
	    delete[] lower_case_name;
	    module_file << module_with_string;
	    module_file << module_previous;
	    module_file << module_body;
	    module_file.close();
	  }
	  break;
	  
	case AST_Decl::NT_interface:
	  {
	    adabe_interface *interface = adabe_interface::narrow_from_decl(d);
	    string interface_previous = "";
	    string interface_body = "";
	    string interface_with_string;
	    dep_list interface_with;

	    interface->produce_marshal_adb(interface_with,interface_body,interface_previous);
	    interface_with_string = *interface_with.produce("with ");
	    
	    string interface_file_name =
	      remove_dot(interface->get_ada_full_name()) +"-marshal.adb";
	    char *lower_case_name = lower(interface_file_name.c_str());
	    ofstream interface_file(lower_case_name); 
	    delete[] lower_case_name;
	    interface_file << interface_with_string;
	    interface_file << interface_previous;       
	    interface_file << interface_body;
	    interface_file.close();
	  }
	  
	  break;
	default:
	  break;
	}
    }
  if (!first) {
    body += "end " + get_ada_full_name() + ".marshal ;";
  }
}

IMPL_NARROW_METHODS3(adabe_module, AST_Module, adabe_name, UTL_Scope);
IMPL_NARROW_FROM_DECL(adabe_module);
IMPL_NARROW_FROM_SCOPE(adabe_module);


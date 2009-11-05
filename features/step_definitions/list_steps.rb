When /^I fill in "([^\"]*)" as the new list's name$/ do |name|
  fill_in('new_list_name', :with => name)
end

When /^I fill in "([^\"]*)" as the list's name$/ do |name|
  fill_in('list[name]', :with => name)
end

When /^I drag the list "([^\"]*)" above "([^\"]*)"$/ do |list_1_name, list_2_name|
  list_1 = List.find_by_name(list_1_name)
  list_2 = List.find_by_name(list_2_name)
  drag_handle = locate_element("list_#{list_1.id}") { locate_element(:class => 'drag') }
  # a little weird: since we limit to sorting on the y-axis, we have to drag one handle "on" the other
  target = locate_element("list_#{list_2.id}") { locate_element(:class => 'drag') }

  drag_and_drop(drag_handle, :to => target)
end

When /^I hover the list "([^\"]*)"$/ do |list|
  list = List.find_by_name(list)
  hover("list_#{list.id}")
end

When /^I click on the button to delete the list "([^\"]*)"$/ do |list|
  list = List.find_by_name(list)
  click_link("delete_list_#{list.id}")
end

When /^I click the link to add a new list$/ do
  click_link('add_list')
end

Then /^the list "([^\"]*)" should be above "([^\"]*)"$/ do |list_1_name, list_2_name|
  # TODO check that list 1 is above list 2 in the DOM
  (List.find_by_name(list_1_name).position < List.find_by_name(list_2_name).position).should be_true
end

Then /^there should not be a list named "([^\"]*)"$/ do |list|
  locate_element(list).should be_nil
  List.find_by_name(list).should be_nil
end

When /^I click on "([^\"]*)"$/ do |text|
  click_on(text)
end


Given /^the following tasks:$/ do |tasks|
  tasks.hashes.each do |attributes|
    list = List.find_or_create_by_name(attributes['list'])
    Task.create!(:name => attributes['name'], :list => list)
  end
end

Given /^the task "([^\"]*)" is marked as (done|open)$/ do |task, status|
  Task.find_by_name(task).update_attribute(:done, status == 'open' ? false : true)
end

When /^I click the link to add a new task to the list "([^\"]*)"$/ do |list|
  list = List.find_by_name(list)
  locate_element(:id => "list_#{list.id}") { click_link(:class => 'add_task') }
end

module Steam
  module Browser
    class HtmlUnit
      module Actions
        def blur(element, options = {})
          element = locate_element(element) unless element.respond_to?(:xpath)
          page.getFirstByXPath(element.xpath).blur # blur always returns nil
          @page = page.getFirstByXPath(locate_element('body').xpath).click
          respond!
        end
      end
    end
  end
end

When /^I fill in "([^\"]*)" as the new task's name$/ do |name|
  fill_in('new_task_name', :with => name)
  blur(locate_field('new_task_name'))
end

When /^I click somewhere else on the page$/ do
  # huh?
end

When /^I drag the task "([^\"]*)" above "([^\"]*)"$/ do |task_1_name, task_2_name|
  drag(task_1_name, :to => task_2_name)
end

When /^I drag the task "([^\"]*)" to the list "([^\"]*)"$/ do |task, list|
  list = List.find_by_name(list)
  drag(task, :to => "task_#{list.tasks.last.id}")
end

When /^I hover the task "([^\"]*)"$/ do |task|
  task = Task.find_by_name(task)
  hover(:id => "task_#{task.id}")
end

When /^I click on the button to delete the task "([^\"]*)"$/ do |task|
  task = Task.find_by_name(task)
  click_link(:id => "delete_task_#{task.id}")
end

When /^I click the link to add a new list$/ do
  click_link(:id => 'add_list')
end

When /^I fill in "([^\"]*)" as the new list's name$/ do |name|
  fill_in('new_list_name', :with => name)
  blur(locate_field('new_list_name'))
end

Then /^there should be a task named "([^\"]*)" in the list "([^\"]*)"$/ do |task, list|
  list = List.find_by_name(list)
  task = Task.find_by_name(task)

  locate_element(:id => "list_#{list.id}") do
    locate_element("task_#{task.id}").should_not be_nil
  end
  list.tasks.should include(task)
end

Then /^the task "([^\"]*)" should be above "([^\"]*)"$/ do |task_1_name, task_2_name|
  # TODO check that task 1 is above task 2 in the DOM
  (Task.find_by_name(task_1_name).position < Task.find_by_name(task_2_name).position).should be_true
end

Then /^there should not be a task named "([^\"]*)"$/ do |task|
  task = Task.find_by_name(task)

  task.should be_nil
  # locate_element(:id => "task_#{task.id}").should be_nil # how do I test this?
end

Then /^there should be a list named "([^\"]*)"$/ do |list|
  list = List.find_by_name(list)

  list.should_not be_nil
  locate_element(:id => "list_#{list.id}").should_not be_nil
end

Then /^the task "([^\"]*)" should be marked as (done|open)$/ do |task, state|
  task = Task.find_by_name(task)
  task.send(:"#{state}?").should be_true
end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
  status = response.status
  status.respond_to?(:should) ? status.should == 200 : assert_equal(200, status)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^\"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )click on "([^\"]*)"$/ do |text|
  click_on(text)
end

When /^(?:|I )follow "([^\"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )follow "([^\"]*)" within "([^\"]*)"$/ do |link, parent|
  click_link(link, :within => parent)
end

When /^(?:|I )fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )fill in "([^\"]*)" for "([^\"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
When /^(?:|I )fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    # reformat_date!(value) if name =~ /_date/
    When %{I fill in "#{name}" with "#{value}"}
  end
end

When /^(?:|I )select "([^\"]*)" from "([^\"]*)"$/ do |value, field|
  select(value, :from => field)
end

# Use this step in conjunction with Rail's datetime_select helper. For example:
# When I select "December 25, 2008 10:00" as the date and time
When /^(?:|I )select "([^\"]*)" as the date and time$/ do |time|
  select_datetime(time)
end

# Use this step when using multiple datetime_select helpers on a page or
# you want to specify which datetime to select. Given the following view:
#   <%= f.label :preferred %><br />
#   <%= f.datetime_select :preferred %>
#   <%= f.label :alternative %><br />
#   <%= f.datetime_select :alternative %>
# The following steps would fill out the form:
# When I select "November 23, 2004 11:20" as the "Preferred" date and time
# And I select "November 25, 2004 10:30" as the "Alternative" date and time
When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, select|
  select_datetime(datetime, :from => select)
end

# Use this step in conjunction with Rail's time_select helper. For example:
# When I select "2:20PM" as the time
# Note: Rail's default time helper provides 24-hour time-- not 12 hour time. Webrat
# will convert the 2:20PM to 14:20 and then select it.
When /^(?:|I )select "([^\"]*)" as the time$/ do |time|
  select_time(time)
end

# Use this step when using multiple time_select helpers on a page or you want to
# specify the name of the time on the form.  For example:
# When I select "7:30AM" as the "Gym" time
When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" time$/ do |time, time_label|
  select_time(time, :from => time_label)
end

# Use this step in conjunction with Rail's date_select helper.  For example:
# When I select "February 20, 1981" as the date
When /^(?:|I )select "([^\"]*)" as the date$/ do |date|
  # reformat_date!(date)
  select_date(date)
end

# Use this step when using multiple date_select helpers on one page or
# you want to specify the name of the date on the form. For example:
# When I select "April 26, 1982" as the "Date of Birth" date
When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date$/ do |date, date_label|
  # reformat_date!(date)
  select_date(date, :from => date_label)
end

When /^(?:|I )check "([^\"]*)"$/ do |field|
  check(field)
end

When /^(?:|I )uncheck "([^\"]*)"$/ do |field|
  uncheck(field)
end

When /^(?:|I )choose "([^\"]*)"$/ do |field|
  choose(field)
end

When /^(?:|I )attach the file at "([^\"]*)" to "([^\"]*)"$/ do |path, field|
  attach_file(field, path)
end

Then /^(?:|I )should see "([^\"]*)"$/ do |text|
  assert_contain(text)
end

Then /^(?:|I )should see "([^\"]*)" within "([^\"]*)"$/ do |text, selector|
  within(selector) { assert_contain(text) }
end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
  assert_contain(Regexp.new(regexp))
end

Then /^(?:|I )should see \/([^\/]*)\/ within "([^\"]*)"$/ do |regexp, selector|
  within(selector) { assert_contain(Regexp.new(regexp)) }
end

Then /^(?:|I )should not see "([^\"]*)"$/ do |text|
  assert_not_contain(text)
end

Then /^(?:|I )should not see "([^\"]*)" within "([^\"]*)"$/ do |text, selector|
  within(selector) { assert_not_contain(text) }
end

Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
  assert_not_contain(Regexp.new(regexp))
end

Then /^(?:|I )should not see \/([^\/]*)\/ within "([^\"]*)"$/ do |regexp, selector|
  within(selector) { assert_not_contain(Regexp.new(regexp)) }
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |selector, text|
  value = locate(:field, selector).value
  value.respond_to?(:should) ? value.should =~ /#{text}/ : assert_match(/#{text}/, value)
end

Then /^the "([^\"]*)" field should not contain "([^\"]*)"$/ do |selector, text|
  value = locate(:field, selector).value
  value.respond_to?(:should) ? value.should_not =~ /#{text}/ : assert_no_match(/#{text}/, value)
end

Then /^the "([^\"]*)" checkbox should be checked$/ do |selector|
  field = locate(:check_box, selector)
  field.respond_to?(:should) ? field.should(be_checked) : assert_equal('checked', field.checked)
end

Then /^the "([^\"]*)" checkbox should not be checked$/ do |selector|
  field = locate(:check_box, selector)
  field.respond_to?(:should) ? field.should_not(be_checked) : assert_not_equal('checked', field.checked)
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  actual = URI.parse(page.url).path
  expected = URI.parse(path_to(page_name)).path
  actual.respond_to?(:should) ? actual.should == expected : assert_equal(expected, actual)
end

register_rb_step_definition /^(?:|I )output the body$/ do
  puts response.body
end

register_rb_step_definition /^(?:|I )(?:show me|browse) the page$/ do
  Steam.save_and_open(request.url, response)
end

DECLARE 
    j apex_json.t_values; 
BEGIN 
    apex_json.parse(j, '{ "foo": 3, "bar": [1, 2, 3, 4] }'); 
    dbms_output.put_line(apex_json.get_count(p_path=>'.',p_values=>j)); -- 2 (foo and bar) 
    dbms_output.put_line(apex_json.get_count(p_path=>'bar',p_values=>j)); -- 4 
END; 



DECLARE 
    j apex_json.t_values; 
begin 
    apex_json.parse(j, '{ "PLACEHOLDERS": { "BRAND": "Fatmoose"}}'); 
    dbms_output.put_line(apex_json.get_count(p_path=>'.',p_values=>j)); 
    dbms_output.put_line(apex_json.get_varchar2(p_path=>'PLACEHOLDERS.BRAND',p_values=>j)); 
END; 


l_placeholders_json := p_placeholders;
    apex_json.parse( p_values => j, p_source => l_placeholders_json);
    l_placeholders_count := apex_json.get_count( p_path => 'placeholder');
    
    for i in 1 .. l_placeholders_count
    loop
      l_brand_value := apex_json.get_varchar2( p_path => 'PLACEHOLDERS[%d].BRAND', p_values => j);
      --l_subj := replace( l_subj, '#BRAND#', apex_json.get_varchar2( p_path => 'BRAND', p0 => 1));
      l_subj := replace( l_subj, '#BRAND#', l_brand_value);
    end loop;
    
    

declare 
    l_cnt number;
    l_subject varchar2(255);
    l_member varchar2(255);
    l_value  varchar2(255);
    l_json clob := '{ "PLACEHOLDERS": { "BRAND": "Fatmoose", "ORDER_NUMBER": "123456", "AAA": "Aaa", "BBB": "Bbb", "CCC": "Ccc"}}';
begin 

    l_subject := 'De #BRAND# test voor order #ORDER_NUMBER#';
    
    apex_json.parse( p_source => l_json); 
    l_cnt := apex_json.get_count( p_path => 'PLACEHOLDERS');
    dbms_output.put_line( l_cnt ||': '||l_subject); 
    
    for i in 1..l_cnt
    loop
      l_member := apex_json.get_members( p_path => 'PLACEHOLDERS')(i); 
      l_value  := apex_json.get_varchar2( p_path => 'PLACEHOLDERS.'||l_member, p0 => i);
      dbms_output.put_line( l_member || ': '||l_value);
      -- dbms_output.put_line( apex_json.get_varchar2( p_path => 'PLACEHOLDERS.'||apex_json.get_members( p_path => 'PLACEHOLDERS')(i), p0 => i)); 
      
      l_subject := replace( l_subject, '#'||l_member||'#', l_value);
      --l_subject := replace( l_subject, '#ORDER_NUMBER#', apex_json.get_varchar2( p_path => 'PLACEHOLDERS.ORDER_NUMBER', p0 => i));
    end loop;
    
    dbms_output.put_line( 'Result: '||l_subject); 
    
end;     

    
DECLARE
    j            apex_json.t_values;
    l_paths apex_t_varchar2;
BEGIN
    apex_json.parse(j, '{ "items": [ { "name": "Amulet of Yendor", "magical": true }, '||
                                     '{ "name": "Slippers",  "magical": "rather not" } ]}');
    l_paths := apex_json.find_paths_like (
        p_values         => j,
        p_return_path => 'items[%]',
        p_subpath       => '.magical',
        p_value           => 'true' );
    dbms_output.put_line('Magical items:');
    for i in 1 .. l_paths.count loop
        dbms_output.put_line(apex_json.get_varchar2(p_values => j, p_path => l_paths(i)||'.name')); 
    end loop;
END;

DECLARE 
    j apex_json.t_values; 
BEGIN 
    apex_json.parse(j, '{ "foo": 3, "bar": [1, 2, 3, 4] }'); 
    dbms_output.put_line(apex_json.get_members(p_path=>'.',p_values=>j)(1)); -- foo
    dbms_output.put_line(apex_json.get_members(p_path=>'.',p_values=>j)(2)); -- bar 
end; 


    
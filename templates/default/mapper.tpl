package {{ current_package }}.{{ module }}.dao;

import {{ current_package }}.common.mybatisplus.CommonMapper;
import {{ current_package }}.{{ module }}.entity.{{ table_name | upper_camel }}Entity;

import java.util.List;

/**
 * {{ table_comment }} Mapper
 *
 * @author {{ author }}
 * @date {{ create_date }}
 */
@Mapper
public interface {{ table_name | upper_camel }}Mapper extends CommonMapper<{{ table_name | upper_camel }}Entity> {
}
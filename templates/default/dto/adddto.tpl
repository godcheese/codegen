package {{ current_package }}.{{ module }}.dto;

import lombok.Data;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * 新增单个{{ table_comment }} DTO
 *
 * @author {{ author }}
 * @date {{ create_date }}
 */
@Data
@Accessors(chain = true)
public class Add{{ table_name | upper_camel }}DTO implements Serializable {

    private static final long serialVersionUID = 1L;
    {% for field in table.fields %}{% if field.column_key != "PRI" %}
    /**
     * {{ field.column_comment }}
     */
    private {% if field.data_type == "bigint" %}Long{% elif field.data_type == "int" %}Integer{% elif field.data_type == "int" %}Integer{% elif field.data_type == "tinyint" %}Integer{% elif field.data_type == "datetime" %}LocalDateTime{% elif field.data_type == "varchar" or field.data_type == "text" or field.data_type == "mediumtext" or field.data_type == "longtext" %}String{% elif field.data_type == "double" %}Double{% endif %} {{ field.column_name | lower_camel }};
 {% endif %}{% endfor %}
}

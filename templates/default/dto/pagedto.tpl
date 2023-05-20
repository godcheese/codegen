package {{ current_package }}.{{ module }}.dto;

import lombok.Data;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * 分页获取多个{{ table_comment }} DTO
 *
 * @author {{ author }}
 * @date {{ create_date }}
 */
@Data
@Accessors(chain = true)
public class Page{{ table_name | upper_camel }}DTO implements Serializable {

    private static final long serialVersionUID = 1L;
    {% for field in table.fields %}
    /**
     * {{ field.column_comment }}
     */
    private {% if field.data_type == "bigint" %}Long{% elif field.data_type == "int" %}Integer{% elif field.data_type == "int" %}Integer{% elif field.data_type == "tinyint" %}Integer{% elif field.data_type == "datetime" %}LocalDateTime{% elif field.data_type == "varchar" %}String{% endif %} {{ field.column_name | lower_camel }};
{% endfor %}
}

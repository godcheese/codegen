package {{ current_package }}.{{ module }}.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;

/**
 * {{ table_comment }} Response
 *
 * @author {{ author }}
 * @date {{ create_date }}
 */
@Data
@Schema(description = "{{ table_comment }} Response")
public class {{ table_name | upper_camel }}Response implements Serializable {

    private static final long serialVersionUID = 1L;
    {% for field in table.fields %}
    /**
     * {{ field.column_comment }}
     */
    @Schema(description = "{{ field.column_comment }}")
    private {% if field.data_type == "bigint" %}Long{% elif field.data_type == "int" %}Integer{% elif field.data_type == "int" %}Integer{% elif field.data_type == "tinyint" %}Integer{% elif field.data_type == "datetime" %}LocalDateTime{% elif field.data_type == "varchar" %}String{% endif %} {{ field.column_name | lower_camel }};
{% endfor %}
}

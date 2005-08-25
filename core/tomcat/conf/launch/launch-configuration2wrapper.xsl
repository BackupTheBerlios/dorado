<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" indent="no"/>
    
    <xsl:param name="os"/>
    
    <xsl:template match="properties[(not (@count) or @count='false')]">
    	<xsl:text>
</xsl:text>
    	<xsl:for-each select="property">
    		<xsl:variable name="property_name">
    			<xsl:value-of select="@name"/>
    		</xsl:variable>
    		<xsl:variable name="property_value">
    			<xsl:value-of select="@value"/>
    		</xsl:variable>
    		<xsl:choose>
    			<xsl:when test="../@type='set'">
    				<xsl:if test="not (os) or os[@name=$os]">
	    				<xsl:call-template name="write_property">
	    					<xsl:with-param name="property_name" 
	    						select="$property_name"/>
	    					<xsl:with-param name="property_value" 
	    						select="$property_value"/>
	    					<xsl:with-param name="prefix" 
	    						select="string('set')"/>
	    				</xsl:call-template>
	    			</xsl:if>
    			</xsl:when>
    			<xsl:otherwise>
    				<xsl:if test="not (os) or os[@name=$os]">
			    		<xsl:call-template name="write_property">
			    			<xsl:with-param name="property_name" 
			    				select="$property_name"/>
			    			<xsl:with-param name="property_value" 
			    				select="$property_value"/>
			    		</xsl:call-template>
			    	</xsl:if>
    			</xsl:otherwise>
    		</xsl:choose>    		
    	</xsl:for-each>
    </xsl:template>
    
    <xsl:template match="properties[@count='true' and not(@basename)]">
    	<xsl:text>
</xsl:text>
    	<xsl:for-each select="property">
    		<xsl:variable name="property_name">
    			<xsl:value-of select="concat(@name, '.', position())"/>
    		</xsl:variable>
    		<xsl:variable name="property_value">
    			<xsl:value-of select="@value"/>
    		</xsl:variable>
    		<xsl:if test="not (os) or os[@name=$os]">
	    		<xsl:call-template name="write_property">
	    			<xsl:with-param name="property_name" select="$property_name"/>
	    			<xsl:with-param name="property_value" select="$property_value"/>
	    		</xsl:call-template>
	    	</xsl:if>
    	</xsl:for-each>
    </xsl:template>
    
    <xsl:template match="properties[@count='true' and @basename]">
    	<xsl:text>
</xsl:text>
    	<xsl:for-each select="property">
    		<xsl:variable name="property_name">
    			<xsl:value-of select="concat(../@basename, '.', position())"/>
    		</xsl:variable>
    		<xsl:variable name="property_value">
    			<xsl:value-of select="@value"/>
    		</xsl:variable>
    		
    		<xsl:if test="not (os) or os[@name=$os]">
	    		<xsl:call-template name="write_property">
	    			<xsl:with-param name="property_name" select="$property_name"/>
	    			<xsl:with-param name="property_value" select="$property_value"/>
	    		</xsl:call-template>
	    	</xsl:if>
    	</xsl:for-each>
    </xsl:template>
    
    <!-- Writes the property. The name and value must be given as parameters -->
    <xsl:template name="write_property">
    	<xsl:param name="property_name"/>
    	<xsl:param name="property_value"/>    	
    	<xsl:param name="prefix">wrapper</xsl:param> 
<xsl:value-of select="concat($prefix,'.',$property_name, '=', $property_value)"/><xsl:text>
</xsl:text>
    </xsl:template>
</xsl:stylesheet>
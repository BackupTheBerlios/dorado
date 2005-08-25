<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" indent="no"/>
    
    <xsl:template match="property-set">
    	<xsl:call-template name="linebreak"/>
    	<xsl:variable name="name" select="@name"/>
    	<xsl:value-of select="concat($name, '=')"/>
    	<xsl:for-each select="item">
    		<xsl:choose>
    			<xsl:when test="position() = last()">
    				<xsl:value-of select="@value"/>
    			</xsl:when>
    			<xsl:otherwise>
    				<xsl:value-of select="concat(@value, ',')"/>
    			</xsl:otherwise>
    		</xsl:choose>
    	</xsl:for-each>
    </xsl:template>
    
    <xsl:template match="property">
    	<xsl:call-template name="linebreak"/>
    	<xsl:choose>
    		<xsl:when test="not (@value) or @value=''">
    			<xsl:value-of select="concat(@name,'=',.)"/>
    		</xsl:when>
    		<xsl:otherwise>
    			<xsl:value-of select="concat(@name,'=',@value)"/>
    		</xsl:otherwise>
    	</xsl:choose>    	
    </xsl:template>
    
    <xsl:template name="linebreak">
    	<xsl:text>
</xsl:text>
    </xsl:template>
</xsl:stylesheet>
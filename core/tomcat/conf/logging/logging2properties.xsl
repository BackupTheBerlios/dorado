<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" indent="no"/>
    
    <xsl:template match="handlers">
    	<xsl:text>
handlers =</xsl:text> 
    	<xsl:for-each select="handler">
    		<xsl:choose>
    			<xsl:when test="position() = last()">
    				<xsl:value-of select="@name"/>
    			</xsl:when>
    			<xsl:otherwise>
    				<xsl:value-of select="concat(@name, ',')"/>
    			</xsl:otherwise>
    		</xsl:choose>
    	</xsl:for-each>    
    	<xsl:for-each select="handler">
    		<xsl:call-template name="linebreak"/>
			<xsl:for-each select="@*[not(name()='name')]">
				<xsl:value-of select="concat(../@name, '.', name(), '=', .)"/>
				<xsl:call-template name="linebreak"/>
			</xsl:for-each>
			<xsl:call-template name="linebreak"/>    	
    	</xsl:for-each>
    </xsl:template>
    
    <xsl:template match="loggers">
    	<xsl:for-each select="logger">
			<xsl:call-template name="linebreak"/>
			<xsl:for-each select="@*[not(name()='name')]">
				<xsl:value-of select="concat(../@name, '.', name(), '=', .)"/>
				<xsl:call-template name="linebreak"/>
			</xsl:for-each>
			<xsl:call-template name="linebreak"/>    		    	
    	</xsl:for-each>
    </xsl:template>
    
    <xsl:template name="linebreak">
    	<xsl:text>
</xsl:text>
    </xsl:template>
</xsl:stylesheet>
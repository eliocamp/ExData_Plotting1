# IMPORTANT: the data is not in the git repo, so this code won't run unless you manually
# place the file into the working directory

# Since I won't be needing all the data, I'll just import the rows I'm interested in.
# First I read jsut the fir colunm, then I look for the dates in need to read
dates<-read.csv("household_power_consumption.txt", header=T, colClasses=c("character",rep("NULL",times=8)),sep=";")

importdates<-c("1/2/2007","2/2/2007")
rows<-dates$Date %in% importdates
f.row<-which.max(rows) # first row I'll need to import
n.row<-sum(rows) # number of rows needed to import

# Now I read the csv file starting from the first row and reading only the ammount 
# of rows i'm interested in. Also, I need to reconstruct the header since is lost 
# by the skip paramter. 

pow.cons<-read.csv("household_power_consumption.txt", sep=";", skip=f.row-1, nrows=n.row, 
                   col.names=c("Date","Time","Global_active_power", "Global_reactive_power",
                               "Voltage", "Global_intensity", "Sub_metering_1",
                               "Sub_metering_2","Sub_metering_3"),
                   na.strings="?")

# Change format to date & time
datetime<-paste(pow.cons$Date,pow.cons$Time)
datetime<-strptime(datetime, "%e/%m/%Y %H:%M:%S")
pow.cons$datetime<-datetime

# Tidy up. 
remove("dates","f.row","importdates","n.row", "rows","datetime")


png(file="figure/plot4.png", width=480, height=480,bg="transparent")
par(mfrow=c(2,2))

# Time series of Global Active Power (dates are in spanish since that's my locale)
plot(pow.cons$datetime, pow.cons$Global_active_power, type="l",xlab="",
     ylab="Global Active Power")

# Time series of Voltage
plot(pow.cons$datetime, pow.cons$Voltage, type="l",xlab="datetime",
     ylab="Voltage")

# Time series of Sub metering stations 
cols<-c("black","red","blue")
plot(pow.cons$datetime, pow.cons$Sub_metering_1,type="l", col=cols[1],
     xlab="",ylab="Energy sub metering")
lines(pow.cons$datetime, pow.cons$Sub_metering_2, col=cols[2])
lines(pow.cons$datetime, pow.cons$Sub_metering_3, col=cols[3])
legend("topright", legend=colnames(pow.cons[,7:9]), lty=1, col=cols, bty="n")

# Time series of Global reactive power
plot(pow.cons$datetime, pow.cons$Global_reactive_power, type="l",xlab="datetime",
     ylab="Global_reactive_power")

dev.off()
